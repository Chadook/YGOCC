function c1504.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetCondition(c1504.spcondition)
	e1:SetValue(c1504.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1504,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c1504.ct)
	e2:SetTarget(c1504.tg)
	e2:SetOperation(c1504.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1,1504)
	e5:SetCondition(c1504.thcon)
	e5:SetTarget(c1504.thtg)
	e5:SetOperation(c1504.thop)
	c:RegisterEffect(e5)
end
function c1504.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end
function c1504.spcondition(e)
	return not e:GetHandler():IsLocation(LOCATION_HAND)
end
function c1504.ct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end	
function c1504.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t={}
	local i=1
	local p=1
	local lv=e:GetHandler():GetLevel()
	for i=2,4 do 
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1504,1))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c1504.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c1504.thcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return pc and pc:IsSetCard(0x5DC)
end
function c1504.filter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToHand()
end
function c1504.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-c:GetSequence())
	if chk==0 then return c:IsAbleToRemove() and pc:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c1504.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	local g=Group.FromCards(c,pc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c1504.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-c:GetSequence())
	if not pc then return end
	local dg=Group.FromCards(c,pc)
	if Duel.Remove(dg,POS_FACEUP,2,REASON_EFFECT)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1504.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and not g:GetFirst():IsHasEffect(EFFECT_NECRO_VALLEY) then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
