--created & coded by Lyris
--「S・VINE」ペガサス
function c101010185.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83274244,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c101010185.ntcon)
	e1:SetOperation(c101010185.nsop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101010185.fdtg)
	e2:SetOperation(c101010185.fdop)
	c:RegisterEffect(e2)
end
function c101010185.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x785e) and c:IsAbleToGraveAsCost()
end
function c101010185.ntcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010185.cfilter,tp,LOCATION_REMOVED,0,1,nil)
end
function c101010185.nsop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010185,0))
	local g=Duel.SelectMatchingCard(tp,c101010185.cfilter,tp,LOCATION_REMOVED,0,1,3,nil)
	local ct=Duel.SendtoGrave(g,REASON_COST+REASON_RETURN)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1400)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(300*ct)
	c:RegisterEffect(e2)
end
function c101010185.thfilter(c)
	return c:IsSetCard(0x785e) and c:IsAbleToHand()
end
function c101010185.trfilter(c)
	return c:IsSetCard(0x785e) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c101010185.fdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c101010185.trfilter,tp,LOCATION_DECK,0,1,nil) and (c:GetFlagEffect(101010185)==0 or bit.band(c:GetFlagEffectLabel(101010185),0x1)~=0x1)
	local b2=Duel.IsExistingMatchingCard(c101010185.thfilter,tp,LOCATION_DECK,0,1,nil) and (c:GetFlagEffect(101010185)==0 or bit.band(c:GetFlagEffectLabel(101010185),0x2)~=0x2)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(101010185,1),aux.Stringid(101010185,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(101010185,1))
	else op=Duel.SelectOption(tp,aux.Stringid(101010185,2))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
function c101010185.fdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c101010185.trfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		if c:GetFlagEffect(101010185)==0 then
			c:RegisterFlagEffect(101010185,RESET_PHASE+PHASE_END,0,1,0x1)
		else
			c:SetFlagEffectLabel(101010185,bit.bor(c:GetFlagEffectLabel(101010185),0x1))
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c101010185.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		if c:GetFlagEffect(101010185)==0 then
			c:RegisterFlagEffect(101010185,RESET_PHASE+PHASE_END,0,1,0x2)
		else
			c:SetFlagEffectLabel(101010185,bit.bor(c:GetFlagEffectLabel(101010185),0x2))
		end
	end
end
