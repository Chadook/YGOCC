--Paintress-Ama Archfiend Goghi
function c16000443.initial_effect(c)
c:SetUniqueOnField(1,0,16000443)
	--synchro summon
	aux.AddSynchroProcedure(c,c16000443.tfilter,aux.NonTuner(Card.IsType,TYPE_NORMAL),1)
	c:EnableReviveLimit()
		--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16000443,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c16000443.sgcon)
	e1:SetTarget(c16000443.sgtg)
	e1:SetOperation(c16000443.sgop)
	c:RegisterEffect(e1)
			local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e0)
		--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16000443,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	--e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,0x1c0)
	e2:SetCountLimit(1,16000443)
	e2:SetTarget(c16000443.target)
	e2:SetOperation(c16000443.operation)
	c:RegisterEffect(e2)
		--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c16000443.atkval)
	c:RegisterEffect(e3)

end

function c16000443.sgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
c16000443.material_setcode=0xc50
function c16000443.tfilter(c)
	return c:IsCode(160007854) --or c:IsHasEffect(20932152)
end
function c16000443.filter(c,p)
	return c:IsType(TYPE_EFFECT) and c:IsAbleToGrave()
end
function c16000443.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c16000443.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*800)
end
function c16000443.sgfilter(c,p)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(p)
end
function c16000443.sgop(e,tp,eg,ep,ev,re,r,rp)

local g=Duel.GetMatchingGroup(c16000443.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local ct=Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.SendtoGrave(g,REASON_EFFECT)
	local lp=Duel.GetLP(tp)
	if ct>0 then
		Duel.SetLP(tp,lp-ct*800)
	end
end
function c16000443.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c16000443.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)

	if g:GetCount()>0 then
			Duel.HintSelection(g)
			local tc=g:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
end
end
function c16000443.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_REMOVED,0,nil,TYPE_NORMAL)*100
end
