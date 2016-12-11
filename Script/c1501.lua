function c1501.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--cannot pendulum summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetCondition(c1501.spcondition)
	e1:SetValue(c1501.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1501,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,1501)
	e2:SetCondition(c1501.condition)
	e2:SetTarget(c1501.target)
	e2:SetOperation(c1501.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1501,1))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,11501)
	e5:SetCondition(c1501.spcon)
	e5:SetTarget(c1501.sptg)
	e5:SetOperation(c1501.spop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1501,2))
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetCondition(c1501.reccon)
	e6:SetTarget(c1501.rectg)
	e6:SetOperation(c1501.recop)
	c:RegisterEffect(e6)
	if not c1501.global_check then
		c1501.global_check=true
		c1501[0]=0
		c1501[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(c1501.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c1501.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c1501.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end
function c1501.spcondition(e)
	return not e:GetHandler():IsLocation(LOCATION_HAND)
end
function c1501.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c1501.filter(c,e,tp)
	return c:IsSetCard(0x5DC) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c1501.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c1501.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1501.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
end
function c1501.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c1501.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	if g:GetCount()>0 then
		Duel.SendtoExtraP(g,nil,REASON_EFFECT)
	end
end
function c1501.spcon(e)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function c1501.spfilter(c)
	return c:IsSetCard(0x5DC) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1501.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1501spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1501.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1501.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1501.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==Duel.GetTurnPlayer() then
		c1501[ep]=c1501[ep]+ev
	end
end
function c1501.clear(e,tp,eg,ep,ev,re,r,rp)
	c1501[2]=c1501[Duel.GetTurnPlayer()]
	c1501[Duel.GetTurnPlayer()]=0
end
function c1501.reccon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c1501.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(c1501[2]/2)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,c1501[2]/2)
end
function c1501.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
